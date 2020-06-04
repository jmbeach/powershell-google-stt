function Start-GoogleSTT (
    $file,
    $uri,
    $sampleRate=1600,
    $encoding = 'ENCODING_UNSPECIFIED',
    $aduioChannelCount = 2,
    $enableSeparateRecognitionPerChannel = $false,
    $languageCode = 'en-US',
    $profanityFilter = $false,
    $enableWordTimeOffsets = $false,
    $enableAutomaticPunctuation = $true,
    $model = 'default') {
    if ($null -eq $env:GOOGLE_API_KEY_STT) {
        Write-Host "Speech to text requires environment variable GOOGLE_API_KEY_STT to be set." -BackgroundColor Red;
        return;
    }

    if ($null -eq $file -and $null -eq $uri) {
        Write-Host "File or URI argument is required" -BackgroundColor Red;
        return;
    }

    if ($null -ne $file) {
        $file = (Get-ChildItem $file).FullName

        if ($null -eq $file) {
            Write-Host "File not found" -BackgroundColor Red;
            return;
        }
    }

    $config = [psobject]::new();
    $config | Add-Member -NotePropertyName 'encoding' -NotePropertyValue $encoding;
    $config | Add-Member -NotePropertyName 'sampleRateHertz' -NotePropertyValue $sampleRate;
    $config | Add-Member -NotePropertyName 'audioChannelCount' -NotePropertyValue $aduioChannelCount;
    $config | Add-Member -NotePropertyName 'enableSeparateRecognitionPerChannel' -NotePropertyValue $enableSeparateRecognitionPerChannel;
    $config | Add-Member -NotePropertyName 'languageCode' -NotePropertyValue $languageCode;
    $config | Add-Member -NotePropertyName 'profanityFilter' -NotePropertyValue $profanityFilter;
    $config | Add-Member -NotePropertyName 'enableWordTimeOffsets' -NotePropertyValue $enableWordTimeOffsets;
    $config | Add-Member -NotePropertyName 'enableAutomaticPunctuation' -NotePropertyValue $enableAutomaticPunctuation;
    $config | Add-Member -NotePropertyName 'model' -NotePropertyValue $model;

    $audio = [psobject]::new();
    if ($null -ne $file) {
        $bytes = [System.IO.File]::ReadAllBytes($file);
        $base64 = [System.Convert]::ToBase64String($bytes);
        $audio | Add-Member -NotePropertyName 'content' -NotePropertyValue $base64;
    } else {
        $audio | Add-Member -NotePropertyName 'uri' -NotePropertyValue $uri;
    }

    $data = [psobject]::new()
    $data | Add-Member -NotePropertyName 'config' -NotePropertyValue $config;
    $data | Add-Member -NotePropertyName 'audio' -NotePropertyValue $audio;
    $response = $null;
    try {
        $response = Invoke-WebRequest -Uri "https://speech.googleapis.com/v1/speech:recognize?key=$env:GOOGLE_API_KEY_STT" -ContentType 'application/json' -Body (ConvertTo-Json $data) -Method POST -UseBasicParsing
    }
    catch {
        if ($null -ne $_.Exception.Response) {
            $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream());
            $errBody = $reader.ReadToEnd();
            Write-Host -ForegroundColor DarkRed $errBody;
        } else {
            Write-Host $_.Exception.Message -ForegroundColor DarkRed;
        }
        
        return
    }

    $audioData = $response.Content | ConvertFrom-Json;
    return $audioData;
}

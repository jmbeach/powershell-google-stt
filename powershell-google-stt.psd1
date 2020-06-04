@{
    RootModule = '.\powershell-google-stt.psm1';
    ModuleVersion = '1.0.0';
    GUID = 'c9607016-8f1a-4100-9d2b-306a4f1153dc';
    Author = 'Jared Beach';
    CompanyName = 'Unknown';
    Copyright = 'None';
    Description = 'Get text from audio files using Google''s Text to Speech API';
    FunctionsToExport = @('*');
    CmdletsToExport = @();
    VariablesToExport = '*';
    AliasesToExport = @();
    FileList = @(
        '.\powershell-google-stt.psm1'
    );
    PrivateData = @{
        PSData = @{
            Tags = @('google', 'stt', 'speech', 'text to speech');
            ProjectUri = 'https://github.com/jmbeach/powershell-google-stt';
        }
    }
}
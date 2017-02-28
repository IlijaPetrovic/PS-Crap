function Compress-File
{
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true
        )]
        [Alias('FullName')]
        $file,

        [Parameter(Mandatory=$true)]
        [string[]]$ZipFile,

        #Use multithreading. Might cause high CPU usage
        [Parameter(Mandatory=$false)]
        [switch]$UseAllThreads
    )

    Begin
    {
        $zipArchive = [Ionic.Zip.ZipFile]::new($ZipFile, [System.Text.Encoding]::Unicode )
        
        if ( -not ($UseAllThreads) )
        {
            $zipArchive.ParallelDeflateThreshold = -1
        }

        $i=0
        
    }
    Process
    {
        if ( [string]::IsNullOrEmpty($file.FullName) )
        {
            $file = Get-ChildItem $file
        }
        Write-Verbose  ("Working on: {0}. {1}" -f $i, $($file.FullName))
        $zipArchive.AddFile($file.FullName) | Out-Null
        $i++
    }
    End
    {
        $zipArchive.Save($ZipFile)
        $zipArchive.Dispose()
    }
}

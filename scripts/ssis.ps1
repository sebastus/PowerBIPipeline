$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\variables.ps1"

$ProjectFilePath = "C:\Users\Divin\OneDrive - Microsoft\MPP Global\trivialPackage"
$folders = ls -Path $ProjectFilePath -Directory

if ($folders.Count -gt 0)
{
    # Load the IntegrationServices Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices, "+
    "Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91, processorArchitecture=MSIL");

    # Store the IntegrationServices Assembly namespace to avoid typing it every time
    $ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

    # Create a connection to the server
    $sqlConnectionString = "Data Source=" + $sqlSvrEndpoint + ";User ID="+ $sqlSvrLogin +";Password="+ $sqlSvrPassword + ";Initial Catalog=SSISDB"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

    # Create the Integration Services object
    $integrationServices = New-Object "$ISNamespace.IntegrationServices" $sqlConnection

    # Get the catalog
    $catalog = $integrationServices.Catalogs['SSISDB']

    foreach ($filefolder in $folders)
    {
        Write-Host "Creating Folder " $filefolder.Name " ..."

        $folder = $catalog.folders[$filefolder.name]
        if ($folder -eq $null)
        {
            # Create a new folder in SSISDB
            $folder = New-Object $ISNamespace".CatalogFolder" ($catalog, $filefolder.Name, "Folder description")
            $folder.Create()
        }        
        $folder

        $projects = ls -Path $filefolder.FullName -File -Filter *.ispac -recurse

        if ($projects.Count -gt 0)
        {
            foreach($projectfile in $projects)
            {
                $projectfilename = $projectfile.Name.Replace(".ispac", "")
                Write-Host "Deploying " $projectfilename " project ..."

                
                # Read the project file, and deploy it to the folder
                [byte[]] $projectFileContent = [System.IO.File]::ReadAllBytes($projectfile.FullName)
                $folder.DeployProject($projectfilename, $projectFileContent)
                
            }
        }
        
        
    }
}


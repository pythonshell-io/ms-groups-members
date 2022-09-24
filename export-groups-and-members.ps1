# The Exchange Online Management Module should be installed if it is not already - https://www.powershellgallery.com/packages/ExchangeOnlineManagement/
# Log in using your Global/Exchange admin username and password - supports MFA
Connect-ExchangeOnline

# Initialise a blank array for you to add the groups and members to.
$group_list = @()

# Create an array for all of the Distribution Groups in the organisation
$groups = Get-DistributionGroup

# Loop through each of the groups to pull out their members
foreach ($group in $groups)
{
    # Create an array for each of the members of each of the groups - extracting just their Primary SMTP Address
    $members = Get-DistributionGroupMember $group.PrimarySmtpAddress

    # Loop through each member to create an object with the correct information which will then be added to the $group_list
    foreach ($member in $members)
    {
        $obj = New-Object PSObject
        $obj | Add-Member -MemberType NoteProperty -Name GroupName -Value $group.Name
        $obj | Add-Member -MemberType NoteProperty -Name GroupEmail -Value $group.PrimarySmtpAddress
        $obj | Add-Member -MemberType NoteProperty -Name MemberName -Value $member.Name
        $obj | Add-Member -MemberType NoteProperty -Name MemberEmail -Value $member.PrimarySmtpAddress
        $obj | Add-Member -MemberType NoteProperty -Name MemberType -Value $member.RecipientType
        # After the object has been created, it gets added (appended) to the $group_list array
        $group_list += $obj
    }
}

# The group list can then be exported to a location of your choosing.

$group_list | Export-CSV -NoTypeInformation "C:\Temp\Exported_Groups.csv"
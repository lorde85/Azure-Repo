Import-Module 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'; 
Connect-ExchangeServer -auto -ClientApplication:ManagementShell

$Servers = @("exch01")
$HTTPS_FQDN = "webmail.rslab.dns-cloud.net"
$HTTPS_AUTODISCOVER_FQDN = "autodiscover.rslab.dns-cloud.net"

foreach($Server in $Servers){
	Get-OWAVirtualDirectory -Server $Server | Set-OWAVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/owa" -ExternalURL   "https://$($HTTPS_FQDN)/owa"
	Get-ECPVirtualDirectory -Server $Server | Set-ECPVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/ecp" -ExternalURL   "https://$($HTTPS_FQDN)/ecp"
	Get-OABVirtualDirectory -Server $Server | Set-OABVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/oab" -ExternalURL   "https://$($HTTPS_FQDN)/oab"
	Get-ActiveSyncVirtualDirectory -Server $Server | Set-ActiveSyncVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/Microsoft-Server-ActiveSync" -ExternalURL "https://$($HTTPS_FQDN)/Microsoft-Server-ActiveSync"
	Get-WebServicesVirtualDirectory -Server $Server | Set-WebServicesVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/EWS/Exchange.asmx" -ExternalURL "https://$($HTTPS_FQDN)/EWS/Exchange.asmx"
	Get-MapiVirtualDirectory -Server $Server | Set-MapiVirtualDirectory -InternalURL "https://$($HTTPS_FQDN)/mapi" -ExternalURL  "https://$($HTTPS_FQDN)/mapi"

	Get-ClientAccessServer -identity $Server | Set-ClientAccessServer -AutoDiscoverServiceInternalUri "https://$($HTTPS_AUTODISCOVER_FQDN)/autodiscover/autodiscover.xml" 
    Get-OutlookAnywhere -Identity "$Server\Rpc (Default Web Site)" | Set-OutlookAnywhere -InternalHostname $HTTPS_FQDN -InternalClientsRequireSsl:$true -InternalClientAuthenticationMethod Negotiate -ExternalHostname $HTTPS_FQDN -ExternalClientAuthenticationMethod Negotiate -ExternalClientsRequireSsl:$true -SSLOffloading:$true 
}
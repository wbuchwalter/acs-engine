{
	"$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
	"contentVersion": "1.0.0.0",
	"parameters": {
        {{range .AgentPoolProfiles}}{{template "agentparams.t" .}},{{end}}
        {{template "masterparams.t" .}},
        {{template "openshiftparams.t" .}}
	},
	"variables": {
        {{range $index, $agent := .AgentPoolProfiles}}
            "{{.Name}}Index": {{$index}},
            {{template "openshiftagentvars.t" .}}
            {{if .IsStorageAccount}}
            {{if .HasDisks}}
                "{{.Name}}DataAccountName": "[concat(variables('storageAccountBaseName'), 'data{{$index}}')]",
            {{end}}
            "{{.Name}}AccountName": "[concat(variables('storageAccountBaseName'), 'agnt{{$index}}')]",
            {{end}}
        {{end}}
        {{template "openshiftmastervars.t" .}}
	},
	"resources": [
        {{range .AgentPoolProfiles}}
            {{template "openshiftagentresourcesvmas.t" .}},
        {{end}}
        {{end}}
        {{template "openshiftmasterresources.t" .}}
        ],
	"outputs": {
        {{range .AgentPoolProfiles}}
        {{template "agentoutputs.t" .}}
        {{end}}
        {{template "masteroutputs.t" .}}
	}
}
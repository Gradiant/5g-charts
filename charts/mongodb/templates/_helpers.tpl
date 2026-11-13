{{/*
The ServiceAccount MongoDB runs as.
*/}}
{{- define "mongodb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (printf "%s-mongodb" .Release.Name) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

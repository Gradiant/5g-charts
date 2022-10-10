{{/*
Return the proper images name
*/}}
{{- define "bind9.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.bind9.image "global" .Values.bind9.global) -}}
{{- end -}}
{{/*
Return the proper images name
*/}}
{{- define "bind9.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.bind9.image "global" .Values.bind9.global) -}}
{{- end -}}
{{- define "rtpengine.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.rtpengine.image "global" .Values.rtpengine.global) -}}
{{- end -}}
{{- define "fhoss.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.fhoss.image "global" .Values.fhoss.global) -}}
{{- end -}}
{{- define "kamailio.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.kamailio.image "global" .Values.kamailio.global) -}}
{{- end -}}
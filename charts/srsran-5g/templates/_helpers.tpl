{{/*
Return the proper srsran image name
*/}}
{{- define "srsran.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.srsran "global" .Values.global) -}}
{{- end -}}


{{/*
Return the secret based on imageCredentials
*/}}
{{- define "srsran.dockerconfig" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "srsran.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}.Val
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "srsran.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Return the proper srsue image name
*/}}
{{- define "srsue.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.ue.image "global" .Values.global) -}}
{{- end -}}


{{/*
Return the secret based on imageCredentials
*/}}
{{- define "srsue.dockerconfig" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.ue.image.registry (printf "%s:%s" .Values.ue.image.username .Values.ue.image.password | b64enc) | b64enc }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "srsue.imagePullSecrets" -}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}.Val
{{- end }}
{{- else if .Values.ue.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.ue.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.ue.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.ue.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "srsue.serviceAccountName" -}}
{{- if .Values.ue.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.ue.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ue.serviceAccount.name }}
{{- end -}}
{{- end -}}

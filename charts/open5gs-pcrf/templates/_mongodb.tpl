{{/* The local MongoDB chart always names its Service <release>-mongodb. */}}
{{- define "open5gs.pcrf.mongodbURI" -}}
{{- if .Values.dbURI -}}
{{- tpl .Values.dbURI . -}}
{{- else -}}
{{- $service := default dict .Values.mongodb.service -}}
{{- $port := default 27017 $service.port -}}
{{- $suffix := "" -}}
{{- if ne (int $port) 27017 -}}
{{- $suffix = printf ":%v" $port -}}
{{- end -}}
{{- printf "mongodb://%s-mongodb%s/open5gs" .Release.Name $suffix -}}
{{- end -}}
{{- end -}}

{{- define "open5gs.pcrf.waitForMongoDB" -}}
- name: wait-for-mongodb
  image: {{ include "common.images.image" (dict "imageRoot" .Values.mongodbWait.image "global" .Values.global) }}
  imagePullPolicy: {{ .Values.mongodbWait.image.pullPolicy | quote }}
  securityContext:
    runAsNonRoot: true
    runAsUser: 999
    runAsGroup: 999
    allowPrivilegeEscalation: false
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  env:
    - name: DB_URI
      value: {{ include "open5gs.pcrf.mongodbURI" . | quote }}
    - name: MONGODB_WAIT_TIMEOUT_SECONDS
      value: {{ .Values.mongodbWait.timeoutSeconds | quote }}
    - name: MONGODB_WAIT_INTERVAL_SECONDS
      value: {{ .Values.mongodbWait.retryIntervalSeconds | quote }}
  command: ["/bin/bash", "-ec"]
  args:
    - |
      {{- .Files.Get "resources/wait-for-mongodb.sh" | nindent 6 }}
  resources:
    {{- toYaml .Values.mongodbWait.resources | nindent 4 }}
{{- end -}}

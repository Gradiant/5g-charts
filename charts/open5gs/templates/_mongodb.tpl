{{- define "open5gs.populate.mongodbURI" -}}
{{- tpl .Values.dbURI . -}}
{{- end -}}

{{- define "open5gs.populate.waitForMongoDB" -}}
- name: wait-for-mongodb
  image: {{ include "common.images.image" (dict "imageRoot" .Values.populate.mongodbWait.image "global" .Values.global) }}
  imagePullPolicy: {{ .Values.populate.mongodbWait.image.pullPolicy | quote }}
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
      value: {{ include "open5gs.populate.mongodbURI" . | quote }}
    - name: MONGODB_WAIT_TIMEOUT_SECONDS
      value: {{ .Values.populate.mongodbWait.timeoutSeconds | quote }}
    - name: MONGODB_WAIT_INTERVAL_SECONDS
      value: {{ .Values.populate.mongodbWait.retryIntervalSeconds | quote }}
  command: ["/bin/bash", "-ec"]
  args:
    - |
      {{- .Files.Get "resources/wait-for-mongodb.sh" | nindent 6 }}
  resources:
    {{- toYaml .Values.populate.mongodbWait.resources | nindent 4 }}
{{- end -}}

#!/bin/bash

set -ex

{{- range .Values.jobCommands }}
{{ . }}
{{- end }}
{{- define "ecommerce.selectorLabels" -}}
app.kubernetes.io/name: ecommerce
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ecommerce.labels" -}}
{{ include "ecommerce.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

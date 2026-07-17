{{- define "aire.fullname" -}}
{{ .Values.deploy.project }}-{{ .Values.deploy.app }}{{ .Values.deploy.service }}-{{ .Values.deploy.instance }}
{{- end }}

{{- define "aire.namespace" -}}
{{ .Values.deploy.project }}
{{- end }}

{{- define "aire.image" -}}
{{ .Values.image.repository }}/{{ .Values.deploy.project }}-{{ .Values.deploy.app }}{{ .Values.deploy.service }}:{{ .Values.deploy.version }}
{{- end }}
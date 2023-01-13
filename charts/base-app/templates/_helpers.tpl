
{{- define "base-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "base-app.validations" -}}
{{ required "project required!" .Values.deploy.project }}-{{ required "app required!" .Values.deploy.app }}-{{ required "service required!" .Values.deploy.service }}-{{ required "instance required!" .Values.deploy.instance }}-{{ required "version required!" .Values.deploy.version }}-{{ required "environmentGroup required!" .Values.deploy.environmentGroup }}
{{- end }}

{{- define "base-app.appGroup" -}}
{{ .Values.deploy.project }}-{{ .Values.deploy.environmentGroup }}
{{- end }}

{{- define "base-app.appGroupUnderscore" -}}
{{ .Values.deploy.project }}_{{ .Values.deploy.environmentGroup }}
{{- end }}

{{- define "base-app.appId" -}}
{{ .Values.deploy.project }}-{{ .Values.deploy.app }}
{{- end }}

{{- define "base-app.instanceId" -}}
{{ .Values.deploy.project }}-{{ .Values.deploy.instance }}-{{ .Values.deploy.app }}
{{- end }}

{{- define "base-app.serviceId" -}}
{{ .Values.deploy.project }}-{{ .Values.deploy.instance }}-{{ .Values.deploy.app }}-{{ .Values.deploy.service }}
{{- end }}


{{- define "base-app.namespace" -}}
{{- default .Values.deploy.project .Values.deploy.namespace }}
{{- end }}


{{- define "base-app.hostname" -}}
{{- if .Values.publish.url -}}
{{- .Values.publish.url }}
{{- else }}
{{- if .Values.publish.addProject -}}
{{- .Values.deploy.project }}-
{{- end -}}
{{- .Values.deploy.instance -}}
{{- if .Values.publish.addApp -}}
-{{- .Values.deploy.app -}}
{{- end -}}
{{- if .Values.publish.tier -}}
{{- .Values.publish.tier }}
{{- end -}}
.{{- .Values.publish.baseUrl -}}
{{- end }}
{{- end }}

{{- define "base-app.imageUrl" -}}
{{- if .Values.image.url }}
{{- .Values.image.url }}:{{ .Values.image.tag | default .Values.deploy.version }}
{{- else }}
{{- .Values.image.registry }}/{{ include "base-app.appId" . }}{{ .Values.deploy.service }}:{{ .Values.image.tag | default .Values.deploy.version }}
{{- end }}
{{- end }}


{{- define "base-app.s3Bucket" -}}
{{- if .Values.storage.bucket }}
{{- .Values.storage.bucket }}
{{- else }}
{{- include "base-app.appGroup" . }}-appdata
{{- end }}
{{- end }}

{{- define "base-app.mailFromDomain" -}}
{{- if .Values.mail.from }}
{{- .Values.mail.from }}
{{- else }}$(APP_PROJECT).$(APP_ENV) - $(MAIL_SENDER_TEXT) <$(MAIL_SENDER_ADDR)>
{{- end }}
{{- end }}



{{- define "base-app.db_connection.user" -}}
{{- if .Values.db.separateDbPerInstance }}
{{- default (printf "%s_%s" .Values.deploy.project .Values.deploy.instance) .Values.db.connection.user }}
{{- else }}
{{- default (include "base-app.appGroupUnderscore" .) .Values.db.connection.user }}
{{- end }}
{{- end }}

{{- define "base-app.db_connection.name" -}}
{{- if .Values.db.separateDbPerInstance }}
{{- default (printf "%s_%s" .Values.deploy.project .Values.deploy.instance) .Values.db.connection.catalog }}
{{- else }}
{{- default (include "base-app.appGroupUnderscore" .) .Values.db.connection.catalog }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "base-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "base-app.labels" -}}
helm.sh/chart: {{ include "base-app.chart" . }}
{{ include "base-app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote  }}
app.kubernetes.io/app-project: {{ .Values.deploy.project | quote  }}
app.kubernetes.io/app-name: {{ .Values.deploy.app | quote  }}
app.kubernetes.io/app-service: {{ .Values.deploy.service | quote  }}
app.kubernetes.io/app-instance: {{ .Values.deploy.instance | quote  }}
app.kubernetes.io/app-version: {{ .Values.deploy.version | quote }}
{{- end }}

{{- define "base-app.mainlabels" -}}
helm.sh/chart: {{ include "base-app.chart" . }}
{{ include "base-app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote  }}
app.kubernetes.io/app-project: {{ .Values.deploy.project | quote  }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "base-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "base-app.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "base-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (printf "%s-%s" .Values.deploy.project .Values.deploy.environmentGroup) .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "base-app.iamRoleName" -}}
{{- if .Values.serviceAccount.iamRoleName }}
{{- .Values.serviceAccount.iamRoleName }}
{{- else }}
{{- .Values.serviceAccount.iamRolePrefix }}{{ .Values.deploy.namespace }}-{{ .Values.deploy.project }}-{{ .Values.deploy.environmentGroup }}
{{- end }}
{{- end }}




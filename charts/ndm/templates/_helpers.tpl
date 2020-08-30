{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ndm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ndm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified ndm daemonset app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ndm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ndmOperator.name" -}}
{{- default .Values.ndmOperator.name .Values.ndmOperator.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified ndm operator app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ndmOperator.fullname" -}}
{{- if .Values.ndmOperator.fullnameOverride }}
{{- .Values.ndmOperator.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Values.ndmOperator.name .Values.ndmOperator.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ndm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ndm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define meta labels for ndm components
*/}}
{{- define "ndm.common.metaLabels" -}}
chart: {{ template "ndm.chart" . }}
heritage: {{ .Release.Service }}
openebs.io/version: {{ .Values.release.version | quote }}
{{- end -}}


{{/*
Create match labels for ndm daemonset component
*/}}
{{- define "ndm.matchLabels" -}}
app: {{ template "ndm.name" . }}
release: {{ .Release.Name }}
component: {{ .Values.ndm.componentName | quote }}
{{- end -}}

{{/*
Create component labels for ndm daemonset component
*/}}
{{- define "ndm.componentLabels" -}}
openebs.io/component-name: {{ .Values.ndm.componentName | quote }}
{{- end -}}


{{/*
Create labels for ndm daemonset component
*/}}
{{- define "ndm.labels" -}}
{{ include "ndm.common.metaLabels" . }}
{{ include "ndm.matchLabels" . }}
{{ include "ndm.componentLabels" . }}
{{- end -}}

{{/*
Create match labels for ndm operator deployment
*/}}
{{- define "ndmOperator.matchLabels" -}}
app: {{ template "ndmOperator.name" . }}
release: {{ .Release.Name }}
component: {{ .Values.ndmOperator.name | quote }}
{{- end -}}

{{/*
Create component labels for ndm daemonset component
*/}}
{{- define "ndmOperator.componentLabels" -}}
openebs.io/component-name: {{ .Values.ndmOperator.name | quote }}
{{- end -}}


{{/*
Create labels for ndm daemonset component
*/}}
{{- define "ndmOperator.labels" -}}
{{ include "ndm.common.metaLabels" . }}
{{ include "ndmOperator.matchLabels" . }}
{{ include "ndmOperator.componentLabels" . }}
{{- end -}}

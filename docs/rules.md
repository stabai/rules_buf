<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="#buf_cli"></a>

## buf_cli

<pre>
buf_cli(<a href="#buf_cli-name">name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="buf_cli-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |


<a id="#buf_module"></a>

## buf_module

<pre>
buf_module(<a href="#buf_module-name">name</a>, <a href="#buf_module-config_file">config_file</a>, <a href="#buf_module-srcs">srcs</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="buf_module-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="buf_module-config_file"></a>config_file |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="buf_module-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |


<a id="#buf_workspace"></a>

## buf_workspace

<pre>
buf_workspace(<a href="#buf_workspace-name">name</a>, <a href="#buf_workspace-modules">modules</a>, <a href="#buf_workspace-work_yaml_file">work_yaml_file</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="buf_workspace-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="buf_workspace-modules"></a>modules |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |
| <a id="buf_workspace-work_yaml_file"></a>work_yaml_file |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |


<a id="#buf_generate"></a>

## buf_generate

<pre>
buf_generate(<a href="#buf_generate-name">name</a>, <a href="#buf_generate-workspace">workspace</a>, <a href="#buf_generate-plugins">plugins</a>, <a href="#buf_generate-go_package_prefix">go_package_prefix</a>, <a href="#buf_generate-kwargs">kwargs</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="buf_generate-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="buf_generate-workspace"></a>workspace |  <p align="center"> - </p>   |  none |
| <a id="buf_generate-plugins"></a>plugins |  <p align="center"> - </p>   |  none |
| <a id="buf_generate-go_package_prefix"></a>go_package_prefix |  <p align="center"> - </p>   |  none |
| <a id="buf_generate-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |



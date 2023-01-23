---
page_title: "ocm_machine_types Data Source"
subcategory: ""
description: |-
  List of cloud providers.
---

# ocm_machine_types (Data Source)

List of cloud providers.

## Schema

### Read-Only

- **items** (Attributes List) Items of the list. (see [below for nested schema](#nestedatt--items))

<a id="nestedatt--items"></a>
### Nested Schema for `items`

Read-Only:

- **cloud_provider** (String) Unique identifier of the cloud provider where the machine type is supported.
- **cpu** (Number) Number of CPU cores.
- **id** (String) Unique identifier of the machine type.
- **name** (String) Short name of the machine type.
- **ram** (Number) Amount of RAM in bytes.

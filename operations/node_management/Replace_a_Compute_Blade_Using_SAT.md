# Replace a Compute Blade Using SAT

Replace an HPE Cray EX liquid-cooled compute blade.

## Prerequisites

- The Cray command line interface \(CLI\) tool is initialized and configured on the system. See [Configure the Cray Command Line Interface](../configure_cray_cli.md).

- The Slingshot fabric must be configured with the desired topology.

- The System Layout Service (SLS) must have the desired HSN configuration.

- Check the status of the high-speed network (HSN) and record link status before the procedure.

- The blades must have the coolant drained and filled during the swap to minimize cross-contamination of cooling systems.

  - Review procedures in *HPE Cray EX Coolant Service Procedures H-6199*
  - Review the *HPE Cray EX Hand Pump User Guide H-6200*

- The System Admin Toolkit \(SAT\) is installed and configured on the system.

### Shutdown nodes on the compute blade

1. Verify that the workload manager (WLM) is not using the affected nodes.

1. Shut down the nodes on the target blade.

   Use the `sat bootsys` command to shut down the nodes on the target blade (in this example, `x9000c3s0`).
   Specify the appropriate component name (xname) and BOS
   template for the node type in the following command.

   ```bash
   ncn# BOS_TEMPLATE=cos-2.0.30-slurm-healthy-compute
   ncn# sat bootsys shutdown --stage bos-operations --bos-limit x9000c3s0 --recursive --bos-templates $BOS_TEMPLATE
   ```

### Use SAT to remove the blade from hardware management

1. Power off the slot and delete blade information from HSM.

   Use the `sat swap` command to power off the slot and delete the blade's ethernet interfaces and Redfish endpoints from HSM.

   ```bash
   ncn# sat swap blade -a disable x9000c3s0
   ```

### Replace the Blade Hardware

1. Replace the blade hardware.

   Review the *Remove a Compute Blade Using the Lift* procedure in *HPE Cray EX Hardware Replacement Procedures H-6173* for detailed instructions.

   **CAUTION**: Always power off the chassis slot or device before removal. The best practice is to unlatch
   and unseat the device while the coolant hoses are still connected, then disconnect the coolant hoses.
   If this is not possible, disconnect the coolant hoses, then quickly unlatch/unseat the device (within 10
   seconds). Failure to do so may damage the equipment.

### Use SAT to add the blade to hardware management

1. Use the `sat swap` command to begin discovery for the blade and add it to hardware management.

   ```bash
   ncn# sat swap blade -a enable x10005c0s3
   ```

### Perform updates and boot the nodes

1. Optional: If necessary, update the firmware. Review the [Firmware Action Service (FAS)](../firmware/FAS_Admin_Procedures.md) documentation.

   ```bash
   ncn# cray fas actions create CUSTOM_DEVICE_PARAMETERS.json
   ```

1. Update the System Layout Service (SLS).

   1. Dump the existing SLS configuration.

      ```bash
      ncn# cray sls networks describe HSN --format=json > existingHSN.json
      ```

   1. Copy `existingHSN.json` to `newHSN.json`, edit `newHSN.json` with the changes, then run the following command:

      ```bash
      ncn# curl -s -k -H "Authorization: Bearer ${TOKEN}" https://API_SYSTEM/apis/sls/v1/networks/HSN \
                -X PUT -d @newHSN.json
      ```

1. Reload DVS on NCNs.

1. Power on and boot the nodes.

   Use `sat bootsys` to power on and boot the nodes. Specify the appropriate BOS template for the node type.

    ```bash
    ncn# BOS_TEMPLATE=cos-2.0.30-slurm-healthy-compute
    ncn# sat bootsys boot --stage bos-operations --bos-limit x1005c0s3 --recursive --bos-templates $BOS_TEMPLATE
    ```

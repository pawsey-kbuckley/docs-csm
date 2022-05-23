# Removing a Liquid-cooled blade from a System Using SAT

This procedure will remove a liquid-cooled blade from an HPE Cray EX system.

## Prerequisites

- The Cray command line interface \(CLI\) tool is initialized and configured on the system.

- Knowledge of whether DVS is operating over the Node Management Network (NMN) or the High Speed Network (HSN).

- The Slingshot fabric must be configured with the desired topology for desired state of the blades in the system.

- The System Layout Service (SLS) must have the desired HSN configuration.

- Check the status of the high-speed network (HSN) and record link status before the procedure.

- The blades must have the coolant drained and filled during the swap to minimize cross-contamination of cooling systems.
  - Review procedures in *HPE Cray EX Coolant Service Procedures H-6199*
  - Review the *HPE Cray EX Hand Pump User Guide H-6200*

- The System Admin Toolkit \(SAT\) is installed and configured on the system.

## Procedure

### Prepare the system blade for removal

1. Using the work load manager (WLM), drain running jobs from the affected nodes on the blade. Refer to the vendor documentation for the WLM for more information.

1. Use the `sat bootsys` command to shut down the nodes on the target blade (in this example, `x9000c3s0`.) Specify the appropriate component xname and BOS
   template for the node type in the following command.

   ```bash
   ncn# BOS_TEMPLATE=cos-2.0.30-slurm-healthy-compute
   ncn# sat bootsys shutdown --stage bos-operations --bos-limit x9000c3s0 --recursive --bos-templates $BOS_TEMPLATE
   ```

### Use SAT to remove the blade from hardware management

1. Use the `sat swap` command to power off the slot and delete the blade's ethernet interfaces and Redfish endpoints from HSM.

   ```bash
   ncn# sat swap blade -a disable x9000c3s0
   ```

   This command will also save the MAC addresses, IP addresses, and node xnames from the blade to a JSON document. The document is stored in a file with the following naming convention:

   ```screen
   ethernet-interface-mappings-<blade_xname>-<current_year>-<current_month>-<current_day>.json
   ```

   If a mapping file already exists with the above name, a numeric suffix will be appended to the file name in front of the `.json` extension.

### Remove the blade

1. Remove the blade from the source system.
   Review the *Remove a Compute Blade Using the Lift* procedure in *HPE Cray EX Hardware Replacement Procedures H-6173* for detailed instructions for replacing liquid-cooled blades ([HPE Support](https://internal.support.hpe.com/)).
1. Drain the coolant from the blade and fill with fresh coolant to minimize cross-contamination of cooling systems.
   Review *HPE Cray EX Coolant Service Procedures H-6199*. If using the hand pump, review procedures in the *HPE Cray EX Hand Pump User Guide H-6200* ([HPE Support](https://internal.support.hpe.com/)).
1. Install the blade from the source system in a storage rack or leave it on the cart.

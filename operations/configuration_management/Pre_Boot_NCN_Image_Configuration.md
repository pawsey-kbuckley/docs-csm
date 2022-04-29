# Pre-Boot Configuration of NCN Images

**NOTE:** Some of the documentation linked from this page mentions use of the BOS service. The use of BOS
is only relevant for booting compute nodes and can be ignored when working with NCN images.

This document describes the configuration of a Kubernetes NCN image. The same steps are relevant for modifying
a Ceph image.

1. Locate the NCN Image to be Modified

    This example assumes you want to modify the image that is currently in use by NCNs. However, the steps
    are the same for any NCN SquashFS image.

    ```console
    ncn# cray artifacts get ncn-images k8s/<version>/filesystem.squashfs ./<version>-filesystem.squashfs

    ncn# cray artifacts get ncn-images k8s/<version>/kernel ./<version>-kernel

    ncn# cray artifacts get ncn-images k8s/<version>/initrd ./<version>-initrd

    ncn# export IMS_ROOTFS_FILENAME=<version>-filesystem.squashfs

    ncn# export IMS_KERNEL_FILENAME=<version>-kernel

    ncn# export IMS_INITRD_FILENAME=<version>-initrd
    ```

1. [Import External Image to IMS](../image_management/Import_External_Image_to_IMS.md)

    This document will instruct the admin to set several environment variables, including the three set in
    the previous step.

1. [Create and Populate a VCS Configuration Repository](Create_and_Populate_a_VCS_Configuration_Repository.md)

   **NOTE:** if the image modification is a kernel-level change, a new `initrd` can be created by invoking
   the following script: `/srv/cray/scripts/common/create-ims-initrd.sh`. This script is embedded in the
   NCN SquashFS. After the script completes, a new `initrd` will be available at `/boot/initrd`. CFS will
   automatically make this `initrd` available at the end of the CFS session.

   **WARNING:** if you do not run the above script, **DO NOT** download the initrd or kernel after the
   CFS session completes (see below). CFS will collect `/boot/initrd` and `/boot/vmlinuz` from the modified
   SquashFS. If you do not run the `create-ims-initrd.sh` script, these artifacts will be incorrect and
   will not be able to boot an NCN.

   If you're not modifying anything at the kernel-level there is no need to create a new `initrd`. In
   that case, simply use the existing `initrd`.

1. [Create a CFS Configuration](Create_a_CFS_Configuration.md)

1. [Create an Image Customization CFS Session](Create_an_Image_Customization_CFS_Session.md)

1. Download the Resultant NCN Artifacts

    **NOTE:** `$IMS_RESULTANT_IMAGE_ID` is the IMS image ID returned in the output of the last command
    in the previous step:

    ```console
    ncn# cray cfs sessions describe example --format json | jq .status.artifacts
    ```

    ```console
    ncn# cray artifacts get boot-images $IMS_RESULTANT_IMAGE_ID/rootfs kubernetes-<version>-1.squashfs

    ncn# cray artifacts get boot-images $IMS_RESULTANT_IMAGE_ID/initrd initrd.img-<version>-1.xz

    ncn# cray artifacts get boot-images $IMS_RESULTANT_IMAGE_ID/kernel 5.3.18-150300.59.43-default-<version>-1.kernel
    ```

1. Upload NCN boot artifacts into S3

    This steps assumes that the `docs-csm` RPM is installed.

    ```console
    ncn# /usr/share/doc/csm/scripts/ceph-upload-file-public-read.py --bucket-name ncn-images --key-name 'k8s/<new-version>/filesystem.squashfs' --file-name kubernetes-<version>-1.squashfs

    ncn# /usr/share/doc/csm/scripts/ceph-upload-file-public-read.py --bucket-name ncn-images --key-name 'k8s/<new-version>/initrd' --file-name initrd.img-<version>-1.xz

    ncn# /usr/share/doc/csm/scripts/ceph-upload-file-public-read.py --bucket-name ncn-images --key-name 'k8s/<new-version>/kernel' --file-name <version>-1.kernel
    ```

1. Update NCN Boot Parameters

    Get the existing `metal.server` setting for the xname of the node of interest:

    ```console
    ncn# XNAME=<your-xname>
    ncn# METAL_SERVER=$(cray bss bootparameters list --hosts $XNAME --format json | jq '.[] |."params"' \
         | awk -F 'metal.server=' '{print $2}' \
         | awk -F ' ' '{print $1}')
    ```

    Verify the variable was set correctly: `echo $METAL_SERVER`

    Update the kernel, initrd, and metal server to point to the new artifacts. Note that multiple Xnames can
    be updated at the same time if desired.

    ```console
    ncn# S3_ARTIFACT_PATH=ncn-images/k8s/<new-version>
    ncn# NEW_METAL_SERVER=http://rgw-vip.nmn/$S3_ARTIFACT_PATH

    ncn# PARAMS=$(cray bss bootparameters list --hosts $XNAME --format json | jq '.[] |."params"' | \
         sed "/metal.server/ s|$METAL_SERVER|$NEW_METAL_SERVER|")
    ```

    Verify the value of `$NEW_METAL_SERVER` was set correctly: `echo $PARAMS`

    In the following invocation, `$XNAME` may be one more more Xname.

    ```console
    ncn# cray bss bootparameters update --hosts $XNAME   \
         --kernel "s3://$S3_ARTIFACT_PATH/kernel" \
         --initrd "s3://$S3_ARTIFACT_PATH/initrd" \
         --params "$PARAMS"
    ```

1. [Reboot the NCN](../node_management/Reboot_NCNs.md)

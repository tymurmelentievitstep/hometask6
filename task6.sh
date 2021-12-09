yum install epel-release -y 
yum install lvm2 -y
yum install parted -y

drives=("sdb" "sdc" "sdd" "sde")
cd /dev/null/
for i in "${drives[@]}"
do
  echo $(parted /dev/"$i" --script -- mklabel msdos)
  echo $(parted /dev/"$i" --script -- mkpart primary ext4 0 100%) 
done
# parted
# print all

echo "create physical volumes on top of /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1"
pvcreate /dev/sdb1 /dev/sdc1
pvcreate /dev/sdd1 /dev/sde1

echo "create a volume groups named vol1 and vol2"
vgcreate vol1 /dev/sdb1 /dev/sdc1
vgcreate vol2 /dev/sdd1 /dev/sde1

echo "create two LVs named vlo1 and vol2"
lvcreate -n vol1 -l 100%FREE vol1
lvcreate -n vol2 -l 100%FREE vol2

mkfs.ext4 /dev/vol1/vol1
mkfs.ext4 /dev/vol2/vol2

echo "mount each volume into /mnt/vol1 /mnt/vol2"
mkdir /mnt/vol1
mkdir /mnt/vol2
mount /dev/vol1/vol1 /mnt/vol1
mount /dev/vol2/vol2 /mnt/vol2

uuidVol1=$(blkid -s UUID -o value /dev/vol1/vol1)
uuidVol2=$(blkid -s UUID -o value /dev/vol2/vol2)
echo "UUID=${uuidVol1} /mnt/vol1  ext4 defaults 0 0">> /etc/fstab
echo "UUID=${uuidVol2} /mnt/vol2  ext4 defaults 0 0">> /etc/fstab
blkid

sudo lsblk
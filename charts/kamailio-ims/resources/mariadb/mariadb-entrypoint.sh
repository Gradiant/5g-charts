ROOT_USER_EXISTS=`mysql -u root --password=${MARIADB_ROOT_PASSWORD} -s -N -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE User = 'root' AND Host = '%')"`
if [[ "$ROOT_USER_EXISTS" == 0 ]]
then
	echo "Creating user 'root'@'%'"
	mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MARIADB_ROOT_PASSWORD}')";
else
	echo "User 'root'@'%' already exists..."
fi
# Grants privileges and sets blank password so FHoSS can access directly
mysql -u root --password=ims -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION";
mysql -u root --password=ims -e "ALTER USER 'root'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('')"
mysql -u root --password=ims -e "FLUSH PRIVILEGES;"
<html><head></head>
<body>
<?php
$env = getenv();
$host = "127.0.0.1";
$username = isset($env["MYSQL_ROOT_USERNAME"]) ? $env["MYSQL_ROOT_USERNAME"] : "";
$password = isset($env["MYSQL_ROOT_PASSWORD"]) ? $env["MYSQL_ROOT_PASSWORD"] : "";
$version = isset($_GET["version"]) ? $_GET["version"] : "";
if (!in_array($version, ["4.7.7"])) $version = "";
if ($version == "")
{
?>
<div>
<a href='?version=4.7.7'>Adminer 4.7.7</a><br/>
</div>
<?php
}
else
{
?>
<div>
	Redirect. Please wait...
	<form id="adminer_form" method="post" action="adminer-<?= $version ?>.php">
		<input type='hidden' name='auth[driver]' value='server' />
		<input type='hidden' name='auth[server]' value="<?= htmlspecialchars($host) ?>" />
		<input type='hidden' name='auth[username]' value="<?= htmlspecialchars($username) ?>" />
		<input type='hidden' name='auth[password]' value="<?= htmlspecialchars($password) ?>" />
		<input type='hidden' name='auth[permanent]' value='1' />
	</form>
	<script>
		adminer_form.submit();
	</script>
</div>
<?php } ?>
</body>
</html>
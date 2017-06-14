<html>
  <head>
    <title><?= $_[0]->{title} ?></title>
  </head>
  <body>
    <h1><?= $_[0]->{title} ?></h1>

? for my $err (@{$_[0]->{errors}}) {
    <p><font color="red"><?= $err ?></font></p>
? }

    <form action="/new" method="POST" enctype="application/x-www-form-urlencoded">
      <input type="hidden" name="comfirm" value="1">
      <table>
          <tr>
              <td align="right">お名前：</td>
              <td><input type="text" name="name" size="30" value="<?= $_[0]->{name} ?>"></td>
          </tr>
          <tr>
              <td align="right">メールアドレス：</td>
              <td><input type="text" name="email" size="30" value="<?= $_[0]->{email} ?>"></td>
          </tr>
          <tr>
              <td align="right">メッセージ：</td>
              <td><textarea name="msg" rows="10" cols="80"><?= $_[0]->{msg} ?></textarea></td>
          </tr>
      </table>
      <table>
          <tr>
              <td>
                  <input type="submit" value="送信内容を確認する">
              </td>
              <td>
                  <input type="reset" value="リセット">
              </td>
          </tr>
      </table>
    </form>
  </body>
</html>


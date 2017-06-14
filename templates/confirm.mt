<html>
  <head>
    <title><?= $_[0]->{title} ?></title>
  </head>
  <body>
    <h1><?= $_[0]->{title} ?></h1>

    <h2>送信内容を確認してください</h2>

    <table>
      <tr>
        <td align="right">お名前：</td>
        <td><?= $_[0]->{name} ?></td>
      </tr>
      <tr>
        <td align="right">メールアドレス：</td>
        <td><?= $_[0]->{email} ?></td>
      </tr>
      <tr>
        <td align="right">メッセージ：</td>
        <td><?= $_[0]->{msg} ?></td>
      </tr>
    </table>

    <table>
      <tr>
        <td>
          <form action="/mail" method="POST" enctype="application/x-www-form-urlencoded">
            <input type="hidden" name="name" value="<?= $_[0]->{name} ?>">
            <input type="hidden" name="email" value="<?= $_[0]->{email} ?>">
            <input type="hidden" name="msg" value="<?= $_[0]->{msg} ?>">
            <input type="submit" value="送信する">
          </form>
        </td>
        <td>
          <form action="/new" method="GET" enctype="application/x-www-form-urlencoded">
            <input type="hidden" name="name" value="<?= $_[0]->{name} ?>">
            <input type="hidden" name="email" value="<?= $_[0]->{email} ?>">
            <input type="hidden" name="msg" value="<?= $_[0]->{msg} ?>">
            <input type="submit" value="修正する">
          </form>
        </td>
      </tr>
    </table>
  </body>
</html>


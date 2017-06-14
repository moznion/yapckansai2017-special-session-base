<html>
  <head>
    <title><?= $_[0]->{title} ?></title>
  </head>
  <body>
    <h1><?= $_[0]->{title} ?></h1>

    <h2>以下の内容で送信しました</h2>

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

    <p>ありがとうございました</p>
    <p><a href="/new">トップへ戻る</a></p>
  </body>
</html>


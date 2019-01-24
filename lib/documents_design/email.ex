defmodule DocumentsDesign.Email do
  import Bamboo.Email

  def verify_email(user) do
    new_email
    |> to({user.name, user.email})
    |> from({System.get_env("MAIL_FROM"), System.get_env("SMTP_USERNAME")})
    |> subject("Vérifiez votre compte sur documents.design")
    |> text_body("""
    Vous avez créé un compte sur documents.design.
    Entrez le code ci-dessous sur la page de vérification de compte qui s'est ouverte.
    #{user.verify_token}
    """)
  end
end

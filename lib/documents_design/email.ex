defmodule DocumentsDesign.Email do
  import Bamboo.Email

  defp mail_base(user) do
    new_email()
    |> to({user.name, user.email})
    |> from({System.get_env("MAIL_FROM"), System.get_env("SMTP_USERNAME")})
  end

  def verify_email(user) do
    user
    |> mail_base()
    |> subject("Vérifiez votre compte sur documents.design")
    |> text_body("""
    Vous avez créé un compte sur documents.design.
    Entrez le code ci-dessous sur la page de vérification de compte qui s'est ouverte.
    #{user.verify_token}
    """)
  end

  def reset_mail(user) do
    user
    |> mail_base()
    |> subject("Demande de changement de mot de passe sur documents.design")
    |> text_body("""
    Vous avez créé demandé un changement de mot de passe.
    Entrez le code ci-dessous sur la page de vérification qui s'est ouverte.
    #{user.reset_token}

    Si vous n'êtes pas à l'origine de cela, ignorez cet e-mail.
    """)
  end

  def reset_mail_done(user) do
    user
    |> mail_base()
    |> subject("Mot de passe changé sur documents.design")
    |> text_body("""
    Votre mot de passe sur documents.design a bien été changé.

    Si vous n'êtes pas à l'origine de cela, contactez-nous.
    """)
  end
end

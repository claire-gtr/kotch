module ReasonHelper
  def many_mails
    "Je reçois trop d'emails"
  end

  def not_relevant
    "Le contenu n’est pas pertinent"
  end

  def not_interested
    "Je ne suis pas intéressé"
  end

  def stop_receive_mails
    "Je ne veux plus recevoir d’emails"
  end

  def others
    "Autres (à compléter ci-dessous)"
  end

  def all_reasons
    [many_mails, not_relevant, not_interested, stop_receive_mails, others]
  end
end

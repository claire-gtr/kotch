import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'duration',
    'intensity',
    'description',
    'defaultText',
    'infoText'
  ]

  sportSelect(event) {
    const sport = event.currentTarget.value;
    this.defaultTextTarget.classList.add('hidden');
    this.infoTextTarget.classList.remove('hidden');

    switch (sport) {
      case "HIIT":
        this.descriptionTarget.textContent = "exercices de forte intensité en alternance avec des courtes périodes de récupération";
        this.intensityTarget.textContent = "élevé";
        this.durationTarget.textContent = "60 min";
        break;
      case "Cross Training":
        this.descriptionTarget.textContent = "circuits d’exercices variés permettant une préparation physique complète (cardio et renforcement musculaire)";
        this.intensityTarget.textContent = "élevé";
        this.durationTarget.textContent = "60 min";
        break;
      case "Fit Boxing":
        this.descriptionTarget.textContent = "exercices de cardio et renforcement musculaire à l’aide de techniques empruntées aux sports de combats et arts martiaux";
        this.intensityTarget.textContent = "élevé";
        this.durationTarget.textContent = "60 min";
        break;
      case "Cuisses Abdos Fessiers":
        this.descriptionTarget.textContent = "exercices de renforcement musculaire ciblés";
        this.intensityTarget.textContent = "faible";
        this.durationTarget.textContent = "45 min";
        break;
      case "Yoga":
        this.descriptionTarget.textContent = "activité douce alliant travail du corps et de l’esprit";
        this.intensityTarget.textContent = "faible";
        this.durationTarget.textContent = "45 min";
        break;
      case "Pilate":
        this.descriptionTarget.textContent = "activité douce alliant travail de postures et de respiration";
        this.intensityTarget.textContent = "faible";
        this.durationTarget.textContent = "45 min";
        break;
      case "Stretching":
        this.descriptionTarget.textContent = "activité douce alliant contractation et relâchement des muscles de manière lente et maîtrisée";
        this.intensityTarget.textContent = "faible";
        this.durationTarget.textContent = "45 min";
        break;
      case "Renforcement musculaire":
        this.descriptionTarget.textContent = "activité complète travaillant la tonicité, le rééquilibrage musculaire et la posture";
        this.intensityTarget.textContent = "moyen";
        this.durationTarget.textContent = "60 min";
        break;
      default:
        this.defaultTextTarget.classList.remove('hidden');
        this.infoTextTarget.classList.add('hidden');
        this.descriptionTarget.textContent = "...";
        this.intensityTarget.textContent = "...";
        this.durationTarget.textContent = "...";
        console.log("Erreur, sport non-reconnu");
    }
  }

  down(event) {
    const lessonID = event.currentTarget.dataset.id;
    const chevronUp = document.querySelector(`.chevronUp-${lessonID}`);
    const hiddenBtn = document.querySelector(`.hidden-lesson-btn-${lessonID}`);
    const hiddenBtnCancel = document.querySelector(`.hidden-lesson-btn-cancel-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronUp.classList.remove('hidden');
    hiddenBtn.classList.remove('hidden');
    hiddenBtnCancel.classList.remove('hidden');
  }

  up(event) {
    const lessonID = event.currentTarget.dataset.id;
    const chevronDown = document.querySelector(`.chevronDown-${lessonID}`);
    const hiddenBtn = document.querySelector(`.hidden-lesson-btn-${lessonID}`);
    const hiddenBtnCancel = document.querySelector(`.hidden-lesson-btn-cancel-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronDown.classList.remove('hidden');
    hiddenBtn.classList.add('hidden');
    hiddenBtnCancel.classList.add('hidden');
  }
}

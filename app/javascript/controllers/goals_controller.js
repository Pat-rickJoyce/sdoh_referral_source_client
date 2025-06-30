// app/javascript/controllers/goals_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "categorySelect",
    "descriptionSelect",
    "submitButton"
  ];

  connect() {
    this.descriptionOptionsJSON = JSON.parse(this.data.get("descriptionOptions"));
    this.categorySelectTarget.addEventListener(
      "change",
      this.handleCategoryChange.bind(this)
    );

    // Add event listener for modal show event
    const modalElement = document.getElementById("add-referral-modal");
    // Add event listener for the submit button
    this.submitButtonTarget.addEventListener(
      "click",
      this.handleSubmit.bind(this)
    );
  }

  handleCategoryChange() {
    const selectedCategory = this.categorySelectTarget.value;
    this.updateDescriptionOptions(selectedCategory);
  }

  handleSubmit(event) {
    const errorDiv = document.getElementById("goals-errors");
    errorDiv.style.display = "none";
    errorDiv.textContent = "";
    const hasCategory = this.categorySelectTarget.value.trim();
    const hasDescription = this.descriptionSelectTarget.value.trim();
    if( !hasCategory ){
      event.preventDefault();
      errorDiv.style.display = "block";
      errorDiv.textContent = "Select a Category";
    } else if( !hasDescription ) {
      event.preventDefault();
      errorDiv.style.display = "block";
      errorDiv.textContent = "Select a Goal";
    }
    else{
      event.preventDefault(); // Prevent the default form submission behavior
      const formElement = document.getElementById("goal-form");
      formElement.submit(); // Manually submit the form
    }
  }

  updateDescriptionOptions(selectedCategory) {
    this.descriptionSelectTarget.innerHTML = "";
    this.descriptionSelectTarget.disabled = true;

    if (!selectedCategory) return;

    const descriptionOptions = this.descriptionOptionsJSON[selectedCategory] || [];
    this.descriptionSelectTarget.innerHTML=`<option value="">Select a Goal</option>`;
    descriptionOptions.forEach(descriptionOption => {
      const opt = document.createElement("option");
      opt.value = descriptionOption[1];
      opt.text = descriptionOption[0];
      this.descriptionSelectTarget.add(opt);
      this.descriptionSelectTarget.disabled = false;
    });
  }
}

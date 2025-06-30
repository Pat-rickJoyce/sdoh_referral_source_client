// app/javascript/controllers/conditions_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "categorySelect",
    "icd10Code",
    "icd10Desc",
    "snomedCode",
    "snomedDesc"
  ];

  connect() {
    this.descriptionOptions = JSON.parse(this.data.get("descriptionOptionsCondition"));
  }

  submit(e) {
    const errorDiv = document.getElementById("conditions-errors");
    errorDiv.style.display = "none";
    errorDiv.textContent = "";
    const hasCategory = this.categorySelectTarget.value.trim();
    const hasICD = this.icd10CodeTarget.value.trim() && this.icd10DescTarget.value.trim();
    const hasSNOMED = this.snomedCodeTarget.value.trim() && this.snomedDescTarget.value.trim();
    if( !hasCategory ){
      e.preventDefault();
      errorDiv.style.display = "block";
      errorDiv.textContent = "Select a Category";
    }
    else if( !hasICD && !hasSNOMED ){
      e.preventDefault();
      errorDiv.style.display = "block";
      errorDiv.textContent = "Select ICD10 and/or SNOMED";
    }
  }

  handleCategoryChange(e) {
    const selectedCategory = e.target.value;
    if (!selectedCategory || selectedCategory === 'default') {
      this.disableOptions(true);
      return;
    }
    this.disableOptions(false);

    const items = this.descriptionOptions[selectedCategory] || [];
    this.items=items;
    items.forEach(item => {
      const display = item[0];
      const code = item[1];
      const isICD10 = /^[A-Za-z]/.test(code);
      if(isICD10) {
        this.icd10CodeTarget.innerHTML+=`<option value="${code}">${code}</option>`;
        this.icd10DescTarget.innerHTML+=`<option value="${display}">${display}</option>`;
      } else {
        this.snomedCodeTarget.innerHTML+=`<option value="${code}">${code}</option>`;
        this.snomedDescTarget.innerHTML+=`<option value="${display}">${display}</option>`;
      }
    });
  }

  disableOptions(e) {
    this.icd10CodeTarget.disabled = e;
    this.icd10DescTarget.disabled = e;
    this.snomedCodeTarget.disabled = e;
    this.snomedDescTarget.disabled = e;

    this.icd10CodeTarget.innerHTML=`<option value="">Select a ICD-10 Code</option>`;
    this.icd10DescTarget.innerHTML=`<option value="">Select a ICD-10 Description</option>`
    this.snomedCodeTarget.innerHTML=`<option value="">Select a SNOMED Code</option>`
    this.snomedDescTarget.innerHTML=`<option value="">Select a SNOMED Description</option>`
  }

  handleCodeChange(e){
    const target = e.target;
    const code = target.value;
    const match = this.items.find(i=>i[1] === code);

    if(target === this.icd10CodeTarget){
      this.icd10DescTarget.value=match ? match[0]: "";
    }
    else if(target === this.snomedCodeTarget){
      this.snomedDescTarget.value=match ? match[0]: "";
    }
  }

  handleDescriptionChange(e){
    const target = e.target;
    const display = target.value;
    const match = this.items.find(i=>i[0] === display);

    if(target === this.icd10DescTarget){
      this.icd10CodeTarget.value=match ? match[1]: "";
    }
    else if(target === this.snomedDescTarget){
      this.snomedCodeTarget.value=match ? match[1]: "";
    }
  }

}

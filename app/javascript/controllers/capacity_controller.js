// app/javascript/controllers/capacity_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["badge"];

  async check(e) {
    const orgId = e.currentTarget.dataset.orgId;
    if (!orgId) return;

    const badge = this.badgeTargets.find(b => b.dataset.orgId === orgId);
    if (!badge) return;

    badge.textContent = "Checking…";
    badge.classList.remove("bg-success", "bg-danger", "bg-warning", "bg-secondary");

    try {
      const { capacity } = await fetch(`/organizations/${orgId}/check_capacity`).then(r => r.json());

      if (capacity === "at-capacity") {
        badge.textContent = "At Capacity";
        badge.classList.add("bg-danger");
      } else if (capacity === "has-waitlist") {
        badge.textContent = "Has Waitlist";
        badge.classList.add("bg-warning");
      } else if (capacity === "unknown") {
        badge.textContent = "Unknown";
        badge.classList.add("bg-secondary");
      } else {
        badge.textContent = "Available";
        badge.classList.add("bg-success");
      }
    } catch (err) {
      badge.textContent = "Unknown";
      badge.classList.add("bg-secondary");
    }
  }
}

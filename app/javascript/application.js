// This file ensures Rails UJS is loaded for method: :delete links in system specs
import "@rails/ujs";

if (window.Rails) {
  Rails.start();
}

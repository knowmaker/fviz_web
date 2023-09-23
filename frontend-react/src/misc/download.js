






function download(image) {
  const a = document.createElement("a");
  a.href = image;
  a.download = "представление.jpg";
  a.click();
}
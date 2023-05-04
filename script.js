const form = document.getElementById('upload-form');
const fileInput = document.getElementById('file-input');
const resultDiv = document.getElementById('result');
const resultText = document.getElementById('result-text');
const resultConfidence = document.getElementById('result-confidence');


form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append('file', fileInput.files[0]);

    const response = await fetch('https://asia-south1-potato-disease-openlab.cloudfunctions.net/predicthis', {
        method: 'POST',
        body: formData
    });

    const data = await response.json();

    resultText.innerText = data.class;
    resultConfidence.innerText = `Confidence: ${data.confidence*100}%`;
    const uploadedImage = document.getElementById('uploaded-image');
    uploadedImage.src = URL.createObjectURL(fileInput.files[0]);


    

    resultDiv.classList.remove('hidden');
});

fileInput.addEventListener('change', () => {
    const fileName = fileInput.files[0].name;
    const fileLabel = document.getElementById('file-label');
    fileLabel.innerText = fileName;
});

resultDiv.addEventListener('click', () => {
    resultDiv.classList.add('hidden');
    resultText.innerText = '';
    resultConfidence.innerText = '';
    fileInput.value = '';
    document.getElementById('file-label').innerText = 'Choose an image';
});

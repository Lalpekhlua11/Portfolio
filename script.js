document.addEventListener('DOMContentLoaded', () => {
    const aboutText = "Welcome to my portfolio! I specialize in both backend and frontend development. I’m passionate about creating efficient and user-friendly applications.";
    const aboutTextElement = document.getElementById('about-text');
    let index = 0;

    function typeWriter() {
        if (index < aboutText.length) {
            aboutTextElement.textContent += aboutText.charAt(index);
            index++;
            setTimeout(typeWriter, 50); // Adjust typing speed here
        }
    }

    typeWriter();
});

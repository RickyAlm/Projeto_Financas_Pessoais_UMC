const ctrlRedirecionar = (() => {
    function getCookie(nome) {
        const cookies = document.cookie.split(';');
        for (let c of cookies) {
            const [chave, valor] = c.trim().split('=');
            if (chave === nome) {
                return decodeURIComponent(valor);
            }
        }
        return null;
    }

    function redirecionarURL(ehArquivoRaiz) {
        const idSessao = getCookie('idSessao');

        if (!idSessao) {
            if (ehArquivoRaiz) {
                window.top.location.href = "loginUsuario/index.html";
                return;
            }
            window.top.location.href = "../loginUsuario/index.html";
        } else {
            console.log("idSessao encontrado:", idSessao);
        }
    }
    
    return {
        redirecionarURL: redirecionarURL
    };
})();

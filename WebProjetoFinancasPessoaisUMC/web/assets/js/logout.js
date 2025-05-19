/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* global Swal */

const ctrlLogout = (function() {
    function logout() {
        Swal.fire({
            title: 'Deseja sair?',
            text: "Você será desconectado do sistema.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sim',
            cancelButtonText: "Não"
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'logout.jsp';
            }
        });
    }
    
    return {
        logout: logout
    };
})();



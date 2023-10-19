

export function Button({children,className,onClick}) {


    const onButtonClick = async (e) => {
        const button = e.target.closest(".btn")
        showLoadingAnimation(button);
        await onClick(e)
        hideLoadingAnimation(button);
    }

    return (
        <button type="button" className={className} onClick={(e) => onButtonClick(e)}>
            <span className='button-text'>
                {children}
            </span>
        </button>
    )
}

function showLoadingAnimation(button) {
    button.classList.add("loading-button");
    button.innerHTML += '<img src="/waitRequest.gif" alt="Loading" class="loading-img"/>';
    button.classList.add("disabled");
}
  
function hideLoadingAnimation(button) {
    button.classList.remove("loading-button");
    button.children[1].remove();
    button.classList.remove("disabled");
}
  
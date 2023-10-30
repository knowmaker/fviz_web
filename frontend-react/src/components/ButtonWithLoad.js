
import React,{useState} from 'react';

export function Button({children,className,onClick}) {


    const [isLoading, setLoadingState] = useState(false);

    const onButtonClick = async (e) => {
        const button = e.target.closest(".btn")
        showLoadingAnimation(button);
        await onClick(e)
        hideLoadingAnimation(button);
    }

    function showLoadingAnimation(button) {
        button.classList.add("loading-button");
        //button.innerHTML += '<img src="/waitRequest.gif" alt="Loading" class="loading-img"/>';
        setLoadingState(true)
        button.classList.add("disabled");
    }

    function hideLoadingAnimation(button) {
        button.classList.remove("loading-button");
        //button.children[1].remove();
        setLoadingState(false)
        button.classList.remove("disabled");
    }    

    return (
        <button type="button" className={className} onClick={(e) => onButtonClick(e)}>
            <span className='button-text'>
                {children}
            </span>
            {isLoading ? (<>
                <img src="/waitRequest.gif" alt="Loading" className="loading-img"/>
            </>) : (null)}
        </button>
    )
}


  

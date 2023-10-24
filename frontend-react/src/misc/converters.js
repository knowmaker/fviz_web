import { EditorState, ContentState } from "draft-js";
import htmlToDraft from "html-to-draftjs";


export function convertMarkdownToEditorState(stateFunction, markdown) {

  const blocksFromHtml = htmlToDraft(markdown);
  const { contentBlocks, entityMap } = blocksFromHtml;
  const contentState = ContentState.createFromBlockArray(contentBlocks, entityMap);
  stateFunction(EditorState.createWithContent(contentState));

}

export function convertToMLTI(M, L, T, I) {

  let MLTIHTMLString = "";
  if (M !== 0) {
    MLTIHTMLString += `M<sup>${M}</sup>`;
  }
  if (L !== 0) {
    MLTIHTMLString += `L<sup>${L}</sup>`;
  }
  if (T !== 0) {
    MLTIHTMLString += `T<sup>${T}</sup>`;
  }
  if (I !== 0) {
    MLTIHTMLString += `I<sup>${I}</sup>`;
  }

  if (M === 0 && L === 0 && T === 0 && I === 0) {
    MLTIHTMLString = 'L<sup>0</sup>T<sup>0</sup>';
  }

  if (M === undefined || L === undefined || T === undefined || I === undefined) {
    MLTIHTMLString = ""
  }

  if (isNaN(M) || isNaN(L) || isNaN(T) || isNaN(I)) {
    MLTIHTMLString = ""
  }

  return MLTIHTMLString;
}


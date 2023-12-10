import React from 'react';
import { Editor } from 'react-draft-wysiwyg';
import { useIntl } from 'react-intl';


export function RichTextEditor({ editorState, setEditorState, readOnly = false }) {

  const intl = useIntl();

  const onEditorStateChange = (editorState) => {
    setEditorState(editorState);
  };

  // settings for editor
  return (
    <Editor
      editorState={editorState}
      onEditorStateChange={onEditorStateChange}
      wrapperClassName=""
      editorClassName={`form-control ${readOnly ? "grey-background" : ""}`}
      toolbarClassName="toolbar-class"
      readOnly={readOnly}
      toolbarHidden={readOnly}

      toolbar={{
        options: ['emoji', 'inline', 'remove'],
        inline: {
          options: ['superscript', 'subscript'],
        },
        emoji: {
          icon: '/svg.svg',
          title: 'Alphabet',
          emojis: [
            "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ",
            "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω",
            "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ",
            "ν", "ξ", "ο", "π", "ρ", "ς", "σ", "τ", "υ", "φ", "χ", "ψ",
            "ω", "∀", "∁", "∂", "∃", "∄", "∅", "∆", "∇"
          ],
        }
      }} />
  );
}

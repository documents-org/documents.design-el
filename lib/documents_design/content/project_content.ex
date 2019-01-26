defmodule DocumentsDesign.Content.ProjectContent do
  alias DocumentsDesign.Content.Metadata
  alias DocumentsDesign.Content.Slider

  defstruct metadata: [
              %Metadata{name: "Date"},
              %Metadata{name: "Lieu"},
              %Metadata{name: "Commanditaire"},
              %Metadata{name: "Collaborateur"},
              %Metadata{name: "Exposition"},
              %Metadata{name: "Publication"},
              %Metadata{name: "Photographie"},
              %Metadata{name: "Participants"},
              %Metadata{name: "Web"}
            ],
            description: "",
            text: "",
            slider: %Slider{}
end

# Architecture Folder

This folder is meant to hold:

- `Architecture.png` - an exported image of the network/domain diagram
- `Network-Diagram.drawio` - the editable source file (draw.io / diagrams.net)

## How I built mine

I used draw.io (diagrams.net) directly in the browser since it's free and exports clean PNGs. I did not try to draw this before building the lab - I built the domain and OU structure first, then diagrammed it afterward once I actually understood how the pieces connected. Trying to plan the whole diagram up front just led to guessing.

The diagram shows:

- The domain controller (DC01) at the top
- The four department OUs (HR, Finance, IT, Sales) underneath
- Security groups nested under each OU
- The Windows 10 client joined to the domain
- The Splunk server receiving logs from the domain controller

A simplified text version of this diagram is in the main `README.md` under "Architecture" so it's visible without needing to open an external file.

If you're rebuilding this lab yourself, I'd suggest sketching the diagram on paper first, then building it in draw.io once you've actually implemented the OU structure in AD Users and Computers - it's much easier to diagram something you've already built than something you're planning.

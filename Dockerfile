FROM mageia:5
RUN urpmi.update -a && urpmi --auto git groff zip --download-all

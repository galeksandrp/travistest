FROM mageia:5
RUN urpmi.update -a && urpmi -q git

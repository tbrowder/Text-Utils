sub do-it(
    Str:D $line,
    :$opt,
    :$debug,
    ) is export {
    
    # test type of param $opt
    # which can be:
    #   undefined
    #   Bool
    #   UInt >= 2
    #
    # should we specify a return
    #   value?

    unless $line {
        die "FATAL: \$line is empty";
    }

    given $opt {
        when Bool {
        }
        default {
        }
    }


   
}
 

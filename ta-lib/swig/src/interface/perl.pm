# This perl snippet is appended to the perl module generated by SWIG
# customizing and extending its functionality

package Finance::TA;

our $VERSION = v0.1.3;

package Finance::TA::TA_Timestamp;

# Redefine &new to a friendler version accepting optional parameters
undef *new;

*new = sub {
    my $pkg = shift;
    my $self = ::Finance::TAc::new_TA_Timestamp();
    if (defined $self) {
        bless $self, $pkg;

        # Handle optional parameters
        if (@_ > 1) {
            ::Finance::TAc::TA_SetDate(@_[0..2], $self);
        }
        if (@_ > 3) {
            ::Finance::TAc::TA_SetTime(@_[3..5], $self);
        }
        if (@_ == 1) { # like: "2004-02-28 15:37:55"
            if ($_[0] =~ /(\d{2,4})-(\d{2})-(\d{2})/) {
                ::Finance::TAc::TA_SetDate($1, $2, $3, $self);
            }
            if ($_[0] =~ /(\d{2}):(\d{2}):(\d{2})/) {
                ::Finance::TAc::TA_SetTime($1, $2, $3, $self);
            }
        }
    }
    return $self;
};


sub GetStringDate {
    my ($self) = @_;
    @res = ::Finance::TAc::TA_GetDate($self);
    return sprintf("%04d-%02d-%02d", @res[1..3]);
}


sub GetStringTime {
    my ($self) = @_;
    @res = ::Finance::TAc::TA_GetTime($self);
    return sprintf("%02d:%02d:%02d", @res[1..3]);
}


sub GetStringTimestamp {
    my ($self) = @_;
    return GetStringDate($self) . " " . GetStringTime($self);
}


package Finance::TA::TA_RetCodeInfo;

# Redefine &new to a friendler version accepting an optional parameter
undef *new;

*new = sub {
    my ($pkg, $code) = @_;
    my $self = ::Finance::TAc::new_TA_RetCodeInfo();
    bless $self, $pkg if defined($self);
    ::Finance::TA::TA_SetRetCodeInfo($code, $self) if defined($code) && defined($self);
    return $self;
};


package Finance::TA::TA_UDBase;

# Wrapper class for TA_UDBase, handling allocation deallocation automatically,
# and providing object-oriented interface

sub new {
    my $pkg = shift;
    my $self;
    my $retCode = ::Finance::TAc::TA_UDBaseAlloc(\$self);
    if (defined $self) {
        bless $self, $pkg;
        ACQUIRE($self);
    }
    return $self;
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        ::Finance::TAc::TA_UDBaseFree($self);
        delete $OWNER{$self};
    }
}

sub AddDataSource {
    my $self = shift;
    ::Finance::TAc::TA_AddDataSource($self, @_);
}

sub History {
    return unless $_[0]->isa('HASH');
    Finance::TA::TA_History->new(@_);
}


sub CategoryTable {
    my $self = shift;
    my @table = ::Finance::TAc::TA_CategoryTable($self);
    if (shift(@table) == $Finance::TA::TA_SUCCESS) {
        return @table;
    } else {
        return;
    }
}

sub SymbolTable {
    my ($self, $symbol) = @_;
    $symbol ||= $TA_DEFAULT_CATEGORY;
    my @table = ::Finance::TAc::TA_SymbolTable($self, $symbol);
    if (shift(@table) == $Finance::TA::TA_SUCCESS) {
        return @table;
    } else {
        return;
    }
}




package Finance::TA::TA_History;

# Wrapper classes arrange access to TA_History members but creation/deletion
# should be done differently.  Instead of doing new_ and delete_ (which
# use malloc/free), TA_HistoryAlloc and TA_HistoryFree has to be used.

sub new {
    #print "alloc history: @_\n";
    my $pkg = shift;
    my $self;
    my @res = ::Finance::TAc::TA_HistoryAlloc(@_);
    if($res[0] == $Finance::TA::TA_SUCCESS && defined($res[1])) {
        $self = $res[1];
        return bless $self, $pkg;
    } else {
        my %hash;
        $hash{retCode} = $res[0];
        return \%hash;  # not blessed!
    }
}

*swig_retCode_get = sub { $::Finance::TA::TA_SUCCESS };

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        #print "free history: @_: ";
        ::Finance::TAc::TA_HistoryFree($self);
        delete $OWNER{$self};
    }
}

# Now prevent accidental direct calls to TA_HistoryAllow/TA_HistoryFree
delete $::Finance::TA::{TA_HistoryAlloc};
delete $::Finance::TA::{TA_HistoryFree};



package Finance::TA::TA_FuncHandle;

sub new {
    my ($pkg, $name) = @_;
    my $self;
    my $retCode = ::Finance::TAc::TA_GetFuncHandle($name, \$self);
    if (defined $self) {
        bless $self, $pkg;
    }
    return $self;
}


sub GetFuncInfo {
    my ($self) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetFuncInfo($self, \$info);
    return $info;
}


sub GetInputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetInputParameterInfo($self, $param, \$info);
    return $info;
}


sub GetOutputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetOutputParameterInfo($self, $param, \$info);
    return $info;
}


sub GetOptInputParameterInfo {
    my ($self, $param) = @_;
    my $info;
    my $retCode = ::Finance::TAc::TA_GetOptInputParameterInfo($self, $param, \$info);
    return $info;
}



package Finance::TA::TA_FuncInfo;

sub new {
    my ($pkg, $handle) = @_;
    my $self;
    my $retCode = ::Finance::TAc::TA_GetFuncInfo($handle, \$self);
    if (defined $self) {
        bless $self, $pkg;
    }
    return $self;
}


package Finance::TA::TA_TradeLog;

# Wrapper class for TA_TradeLog, handling allocation deallocation automatically,
# and providing object-oriented interface

sub new {
    my $pkg = shift;
    my $self;
    my $retCode = ::Finance::TAc::TA_TradeLogAlloc(\$self);
    if (defined $self) {
        bless $self, $pkg;
        ACQUIRE($self);
    }
    #print "creating $self\n";
    return $self;
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    #print "destroying $_[0]\n";
    my $self = tied(%{$_[0]});
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        ::Finance::TAc::TA_TradeLogFree($self);
        delete $OWNER{$self};
    }
}

sub TradeLogAdd {
    my $self = shift;
    ::Finance::TAc::TA_TradeLogAdd($self, @_);
}


package Finance::TA::TA_PM;

# Wrapper class for TA_PM, handling allocation deallocation automatically,
# and providing object-oriented interface

# Keep track which logs are added to PM, not to destroy them too early
%logs = ();

sub new {
    my $pkg = shift;
    my $self;
    my $retCode = ::Finance::TAc::TA_PMAlloc(@_[0..2], \$self);
    if (defined $self) {
        bless $self, $pkg;
        ACQUIRE($self);
    }
    #print "creating $self\n";
    return $self;
}

sub DESTROY {
    my ($self) = @_;
    return unless $self->isa('HASH');
    #print "destroying $self\n";
    my $this = tied(%$self);
    delete $ITERATORS{$this};
    if (exists $OWNER{$this}) {
        ::Finance::TAc::TA_PMFree($this);
        delete $OWNER{$this};
        delete $logs{$self};
    }
}

sub PMAddTradeLog {
    my ($self, $log) = @_;
    push(@{$logs{$self}}, $log);
    ::Finance::TAc::TA_PMAddTradeLog($self, $log);
}

sub PMValue {
    my @res = ::Finance::TAc::TA_PMValue(@_);
    return ($res[0] == $Finance::TA::TA_SUCCESS)? $res[1] : undef;
}

sub PMArray {
    return unless $_[0]->isa('HASH');
    return Finance::TA::TA_PMArray->new(@_);
}

sub TradeReport {
    return unless $_[0]->isa('HASH');
    return Finance::TA::TA_TradeReport->new(@_);
}


package Finance::TA::TA_PMArray;

# Wrapper classes arrange access to TA_PMArray, similarly to TA_History

sub new {
    #print "alloc PMArray: @_\n";
    my $pkg = shift;
    my $self;
    my @res = ::Finance::TAc::TA_PMArrayAlloc(@_);
    if($res[0] == $::Finance::TA::TA_SUCCESS && defined($res[1])) {
        $self = $res[1];
        return bless $self, $pkg;
    } else {
        my %hash;
        $hash{retCode} = $res[0];
        return \%hash;  # not blessed!
    }
}

*swig_retCode_get = sub { $::Finance::TA::TA_SUCCESS };

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        #print "free PMArray: @_: ";
        ::Finance::TAc::TA_PMArrayFree($self);
        delete $OWNER{$self};
    }
}

# Now prevent accidental direct calls to TA_PMArrayAlloc/TA_PMArrayFree
delete $::Finance::TA::{TA_PMArrayAlloc};
delete $::Finance::TA::{TA_PMArrayFree};



package Finance::TA::TA_TradeReport;

# Wrapper classes arrange access to TA_TradeReport, similarly to TA_PMArray

# Keep track which PM is used for Trade Report, not to destroy it too early
# (design limitation of TA_TradeReport)

%PM = ();

sub new {
    #print "alloc TradeReport: @_\n";
    my ($pkg, $pm) = @_;
    my $self;
    my @res = ::Finance::TAc::TA_TradeReportAlloc($pm);
    if($res[0] == $::Finance::TA::TA_SUCCESS && defined($res[1])) {
        $self = $res[1];
        $PM{$self} = $pm;
        #print "new $self\n";
        return bless $self, $pkg;
    } else {
        my %hash;
        $hash{retCode} = $res[0];
        return \%hash;  # not blessed!
    }
}

*swig_retCode_get = sub { $::Finance::TA::TA_SUCCESS };

sub DESTROY {
    my ($self) = @_;
    return unless $self->isa('HASH');
    my $this = tied(%$self);
    return unless defined $self;
    delete $ITERATORS{$this};
    if (exists $OWNER{$this}) {
        #print "free TradeReport: @_: ";
        ::Finance::TAc::TA_TradeReportFree($this);
        delete $OWNER{$this};
        #print "delete $self\n";
        delete $PM{$self};
    }
}

# Now prevent accidental direct calls to TA_TradeReportAlloc/TA_TradeReportFree
delete $::Finance::TA::{TA_TradeReportAlloc};
delete $::Finance::TA::{TA_TradeReportFree};



package Finance::TA;

# Redefine exported TA_Initialize/TA_Shutdown functions 
# to be more "Perl-friendly"

our $INITIALIZED = 0;

undef *TA_Initialize;

*TA_Initialize = sub {
    my $retCode;
    if ($INITIALIZED) {
        $retCode = TA_Shutdown();
        return $retCode if $retCode != $TA_SUCCESS;
    }
    # Accept calls with no parameters
    $_[0] = undef if @_ == 0;
    $retCode = ::Finance::TAc::TA_Initialize(@_);
    $INITIALIZED = ($retCode == $TA_SUCCESS);
    return $retCode;
};

undef *TA_Shutdown;

*TA_Shutdown = sub {
    if ($INITIALIZED) {
        $INITIALIZED = 0;
        return ::Finance::TAc::TA_Shutdown();
    } else {
        # We are more forgiving on multiple calls to &TA_Shutdown
        # than TA-LIB on TA_Shutdown()
        return $TA_SUCCESS;
    }
};

# SWIG does not export anything by default
# This small loop circumvents that and export everything beginning with 'TA_'
foreach (keys %Finance::TA::) {
    if (/^TA_/) {
        local *sym = $Finance::TA::{$_};        
        push(@EXPORT, "\$$_") if defined $sym;
        push(@EXPORT, "\@$_") if defined @sym;
        push(@EXPORT, "\%$_") if defined %sym;
        push(@EXPORT, $_) if defined &sym;
    }
}

END { TA_Shutdown() }

TA_Initialize();
$INITIALIZED;

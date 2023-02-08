public class FFTargetSegment {

    public String name { get; set; }

    public String identifier { get; set; }

    //OPTIONAL
    public String environment { get; set; }
    
    //OPTIONAL
    public List<FFTag> tags { get; set; }
    
    //OPTIONAL
    public List<FFTarget> included { get; set; }

    //OPTIONAL
    public List<FFTarget> excluded { get; set; }

    //OPTIONAL
    public List<FFClause> rules { get; set; }

    //OPTIONAL
    public Integer createdAt { get; set; }

    //OPTIONAL
    public Integer modifiedAt { get; set; }

    //OPTIONAL
    public Integer version { get; set; }

}


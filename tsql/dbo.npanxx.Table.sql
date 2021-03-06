/****** Object:  Table [dbo].[npanxx]    Script Date: 2022-06-02 6:29:20 AM ******/
DROP TABLE [dbo].[npanxx]
GO
/****** Object:  Table [dbo].[npanxx]    Script Date: 2022-06-02 6:29:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[npanxx](
	[npanxx] [char](6) NOT NULL,
	[npa] [char](3) NOT NULL,
	[nxx] [char](3) NOT NULL,
 CONSTRAINT [PK_npanxx] PRIMARY KEY CLUSTERED 
(
	[npanxx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

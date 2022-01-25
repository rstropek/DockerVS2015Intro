﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using ShareForFuture.Data;

#nullable disable

namespace ShareForFuture.Data.Migrations
{
    [DbContext(typeof(S4fDbContext))]
    partial class S4fDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.0-rc.1.21452.10")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder, 1L, 1);

            modelBuilder.Entity("OfferingsTags", b =>
                {
                    b.Property<int>("OfferingsId")
                        .HasColumnType("int");

                    b.Property<int>("TagsId")
                        .HasColumnType("int");

                    b.HasKey("OfferingsId", "TagsId");

                    b.HasIndex("TagsId");

                    b.ToTable("OfferingsTags");
                });

            modelBuilder.Entity("ShareForFuture.Data.Complaint", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("AssignedToId")
                        .HasColumnType("int");

                    b.Property<int>("ComplaineeId")
                        .HasColumnType("int");

                    b.Property<int>("ComplainerId")
                        .HasColumnType("int");

                    b.Property<DateTime>("CreatedTimestamp")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("datetime2")
                        .HasDefaultValueSql("GETDATE()");

                    b.Property<DateTime?>("DoneTimestamp")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("AssignedToId");

                    b.HasIndex("ComplaineeId");

                    b.HasIndex("ComplainerId");

                    b.ToTable("Complaints");
                });

            modelBuilder.Entity("ShareForFuture.Data.ComplaintNote", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("ComplaintId")
                        .HasColumnType("int");

                    b.Property<byte[]>("Picture")
                        .HasColumnType("varbinary(max)");

                    b.Property<string>("TextNote")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.HasIndex("ComplaintId");

                    b.ToTable("ComplaintNotes");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceCategory", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("Id");

                    b.ToTable("DeviceCategories");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceImage", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<byte[]>("ImageData")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<int?>("OfferingId")
                        .IsRequired()
                        .HasColumnType("int");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("Id");

                    b.HasIndex("OfferingId");

                    b.ToTable("DeviceImages");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceSubCategory", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<int>("CategoryId")
                        .HasColumnType("int");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("Id");

                    b.HasIndex("CategoryId");

                    b.ToTable("DeviceSubCategories");
                });

            modelBuilder.Entity("ShareForFuture.Data.Identity", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Provider")
                        .IsRequired()
                        .HasColumnType("nvarchar(450)");

                    b.Property<string>("SubjectId")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("UserId");

                    b.HasIndex("Provider", "SubjectId")
                        .IsUnique();

                    b.ToTable("Identities");
                });

            modelBuilder.Entity("ShareForFuture.Data.Offering", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Condition")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Description")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("LastSuccessfullAvailabilityVerification")
                        .HasColumnType("datetime2");

                    b.Property<int>("SubCategoryId")
                        .HasColumnType("int");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<DateTime?>("UnavailableSince")
                        .HasColumnType("datetime2");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("SubCategoryId");

                    b.HasIndex("UserId");

                    b.ToTable("Offerings");
                });

            modelBuilder.Entity("ShareForFuture.Data.OfferingTag", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Tag")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("Id");

                    b.HasIndex("Tag")
                        .IsUnique();

                    b.ToTable("OfferingTags");
                });

            modelBuilder.Entity("ShareForFuture.Data.Sharing", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("AcceptDeclineMessage")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("AcceptDeclineTimestamp")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("ActivationTimestamp")
                        .HasColumnType("datetime2");

                    b.Property<int>("BorrowerId")
                        .HasColumnType("int");

                    b.Property<int?>("BorrowerRating")
                        .HasColumnType("int");

                    b.Property<string>("BorrowerRatingNote")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("DeviceRating")
                        .HasColumnType("int");

                    b.Property<string>("DeviceRatingNote")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("DoneTimestamp")
                        .HasColumnType("datetime2");

                    b.Property<DateTime>("From")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("LastShareNotificationSendTimestamp")
                        .HasColumnType("datetime2");

                    b.Property<bool?>("LenderHasAccepted")
                        .HasColumnType("bit");

                    b.Property<int?>("LenderRating")
                        .HasColumnType("int");

                    b.Property<string>("LenderRatingNote")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("OfferingId")
                        .HasColumnType("int");

                    b.Property<DateTime>("Until")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("BorrowerId");

                    b.HasIndex("OfferingId");

                    b.ToTable("Sharings");

                    b.HasCheckConstraint("UntilAfterFrom", "[Until] > [From]");
                });

            modelBuilder.Entity("ShareForFuture.Data.UnavailabilityPeriod", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<DateTime>("From")
                        .HasColumnType("datetime2");

                    b.Property<int>("OfferingId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("Until")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.HasIndex("OfferingId");

                    b.ToTable("UnavailabilityPeriods");

                    b.HasCheckConstraint("UntilAfterFrom", "[Until] IS NULL\r\n                OR [Until] > [From]");
                });

            modelBuilder.Entity("ShareForFuture.Data.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("City")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("ContactEmail")
                        .IsRequired()
                        .HasMaxLength(150)
                        .HasColumnType("nvarchar(150)");

                    b.Property<string>("ContactPhone")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("nvarchar(30)");

                    b.Property<string>("Country")
                        .IsRequired()
                        .HasMaxLength(2)
                        .HasColumnType("nchar(2)")
                        .IsFixedLength();

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<DateTime?>("LastSuccessfullEmailVerification")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("LastSuccessfullLogin")
                        .HasColumnType("datetime2");

                    b.Property<string>("MiddleName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Street")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<int?>("UserGroupId")
                        .HasColumnType("int");

                    b.Property<string>("ZipCode")
                        .IsRequired()
                        .HasMaxLength(10)
                        .HasColumnType("nvarchar(10)");

                    b.HasKey("Id");

                    b.HasIndex("ContactEmail")
                        .IsUnique();

                    b.HasIndex("UserGroupId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("ShareForFuture.Data.UserGroup", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("Id");

                    b.HasIndex("Name")
                        .IsUnique();

                    b.ToTable("UserGroups");

                    b.HasData(
                        new
                        {
                            Id = 1,
                            Name = "Regular S4F employee"
                        },
                        new
                        {
                            Id = 2,
                            Name = "Manager"
                        },
                        new
                        {
                            Id = 3,
                            Name = "System administrator"
                        });
                });

            modelBuilder.Entity("OfferingsTags", b =>
                {
                    b.HasOne("ShareForFuture.Data.Offering", null)
                        .WithMany()
                        .HasForeignKey("OfferingsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("ShareForFuture.Data.OfferingTag", null)
                        .WithMany()
                        .HasForeignKey("TagsId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();
                });

            modelBuilder.Entity("ShareForFuture.Data.Complaint", b =>
                {
                    b.HasOne("ShareForFuture.Data.User", "AssignedTo")
                        .WithMany("AssignedComplaints")
                        .HasForeignKey("AssignedToId")
                        .OnDelete(DeleteBehavior.Restrict);

                    b.HasOne("ShareForFuture.Data.User", "Complainee")
                        .WithMany("ComplaintsAbout")
                        .HasForeignKey("ComplaineeId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("ShareForFuture.Data.User", "Complainer")
                        .WithMany("Complaints")
                        .HasForeignKey("ComplainerId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("AssignedTo");

                    b.Navigation("Complainee");

                    b.Navigation("Complainer");
                });

            modelBuilder.Entity("ShareForFuture.Data.ComplaintNote", b =>
                {
                    b.HasOne("ShareForFuture.Data.Complaint", "Complait")
                        .WithMany("Notes")
                        .HasForeignKey("ComplaintId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Complait");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceImage", b =>
                {
                    b.HasOne("ShareForFuture.Data.Offering", "Offering")
                        .WithMany("Images")
                        .HasForeignKey("OfferingId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Offering");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceSubCategory", b =>
                {
                    b.HasOne("ShareForFuture.Data.DeviceCategory", "Category")
                        .WithMany("SubCategories")
                        .HasForeignKey("CategoryId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Category");
                });

            modelBuilder.Entity("ShareForFuture.Data.Identity", b =>
                {
                    b.HasOne("ShareForFuture.Data.User", "User")
                        .WithMany("Identities")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("ShareForFuture.Data.Offering", b =>
                {
                    b.HasOne("ShareForFuture.Data.DeviceSubCategory", "SubCategory")
                        .WithMany("Offerings")
                        .HasForeignKey("SubCategoryId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("ShareForFuture.Data.User", "User")
                        .WithMany("Offerings")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("SubCategory");

                    b.Navigation("User");
                });

            modelBuilder.Entity("ShareForFuture.Data.Sharing", b =>
                {
                    b.HasOne("ShareForFuture.Data.User", "Borrower")
                        .WithMany("Lendings")
                        .HasForeignKey("BorrowerId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("ShareForFuture.Data.Offering", "Offering")
                        .WithMany("Sharings")
                        .HasForeignKey("OfferingId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("Borrower");

                    b.Navigation("Offering");
                });

            modelBuilder.Entity("ShareForFuture.Data.UnavailabilityPeriod", b =>
                {
                    b.HasOne("ShareForFuture.Data.Offering", null)
                        .WithMany("UnavailabilityPeriods")
                        .HasForeignKey("OfferingId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("ShareForFuture.Data.User", b =>
                {
                    b.HasOne("ShareForFuture.Data.UserGroup", "UserGroup")
                        .WithMany("Users")
                        .HasForeignKey("UserGroupId")
                        .OnDelete(DeleteBehavior.Restrict);

                    b.Navigation("UserGroup");
                });

            modelBuilder.Entity("ShareForFuture.Data.Complaint", b =>
                {
                    b.Navigation("Notes");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceCategory", b =>
                {
                    b.Navigation("SubCategories");
                });

            modelBuilder.Entity("ShareForFuture.Data.DeviceSubCategory", b =>
                {
                    b.Navigation("Offerings");
                });

            modelBuilder.Entity("ShareForFuture.Data.Offering", b =>
                {
                    b.Navigation("Images");

                    b.Navigation("Sharings");

                    b.Navigation("UnavailabilityPeriods");
                });

            modelBuilder.Entity("ShareForFuture.Data.User", b =>
                {
                    b.Navigation("AssignedComplaints");

                    b.Navigation("Complaints");

                    b.Navigation("ComplaintsAbout");

                    b.Navigation("Identities");

                    b.Navigation("Lendings");

                    b.Navigation("Offerings");
                });

            modelBuilder.Entity("ShareForFuture.Data.UserGroup", b =>
                {
                    b.Navigation("Users");
                });
#pragma warning restore 612, 618
        }
    }
}

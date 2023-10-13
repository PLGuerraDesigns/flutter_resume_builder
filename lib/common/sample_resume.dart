import 'package:flutter/cupertino.dart';

import '../models/contact.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/generic.dart';
import '../models/resume.dart';

class SampleResume extends Resume {
  SampleResume()
      : super(
          name: 'John Doe',
          location: 'San Francisco, CA',
          skills: <String>[
            'Flutter',
            'Dart',
            'Python',
            'Java',
            'C++',
          ],
          contactList: <Contact>[
            Contact(
              value: 'johndoe@email.com',
              iconData: CupertinoIcons.mail,
            ),
            Contact(
              value: 'linkedin.com/in/jdoe',
              iconData: CupertinoIcons.link,
            ),
            Contact(
              value: '123-456-7890',
              iconData: CupertinoIcons.phone,
            ),
            Contact(
              value: 'example.com/portfolio/jdoe',
              iconData: CupertinoIcons.globe,
            ),
          ],
          experiences: <Experience>[
            Experience(
              company: 'Example Holdings Inc.',
              position: 'Software Engineer',
              startDate: '01/2020',
              endDate: 'Present',
              location: 'San Francisco, CA',
              description:
                  '• Installed and configured software applications and tested solutions for effectiveness.\n• Worked with project managers, developers, quality assurance and customers to resolve\n  technical issues.\n• Interfaced with cross-functional team of business analysts, developers and technical\n  support professionals to determine comprehensive list of requirement specifications for\n  new applications.',
            ),
            Experience(
              company: 'Example Technologies',
              position: 'Software Development Associate',
              startDate: '01/2019',
              endDate: '12/2019',
              location: 'San Francisco, CA',
              description:
                  '• Administered government-supported community development programs and promoted\n  department programs and services.\n• Worked closely with clients to establish problem specifications and system designs.\n• Developed next generation integration platform for internal applications.',
            ),
            Experience(
              position: 'Web Development Intern',
              company: 'Example Appraisal Services',
              startDate: '06/2018',
              endDate: '08/2018',
              location: 'San Francisco, CA',
              description:
                  '• Participated with preparation of design documents for trackwork, including alignments,\n  specifications, criteria details and estimates.\n• Collaborated with senior engineers on projects and offered insight.\n• Engaged in software development utilizing wide range of technological tools and\n  industrial Ethernet-based protocols.',
            )
          ],
          educationHistory: <Education>[
            Education(
              institution: 'Example University',
              degree: 'MS, Software Engineering',
              startDate: '08/2018',
              endDate: '12/2019',
              location: 'San Francisco, CA',
            ),
            Education(
              institution: 'Example State University',
              degree: 'BS, Computer Science',
              startDate: '08/2014',
              endDate: '05/2018',
              location: 'San Francisco, CA',
            ),
          ],
          customSections: <Map<String, GenericEntry>>[
            <String, GenericEntry>{
              'Summary': GenericEntry(
                title: '',
                description:
                    'Technology-driven Software Engineer with 4 years of experience in translating business requirements and functional specification into code modules and software solutions. Deep understanding of system integration testing (SIT) and user acceptance testing (UAT). Engages in the software development lifecycle to support the development, configuration, modification, and testing of integrated business and enterprise application solutions. Drives the adoption of new technologies by researching innovative technology trends and developments.',
              ),
            },
            <String, GenericEntry>{
              'Projects': GenericEntry(
                  title: 'Inventory Management System',
                  description:
                      '• Developed a mobile application for a local business to manage their inventory and sales.\n• Utilized Flutter and Firebase to create a cross-platform application for Android and iOS.\n• Implemented a barcode scanner to scan products and update inventory in real-time.\n• Designed a user interface to display sales and inventory data in a visually appealing manner.'),
            },
            <String, GenericEntry>{
              'Projects': GenericEntry(
                  title: 'Project Management System',
                  description:
                      '• Built a web application to manage and track the progress of projects.\n•  Utilized Flutter and GitHub Pages to create a web application for desktop and mobile.\n')
            }
          ],
          hiddenSections: <String>['Skills'],
          sectionOrder: <String>[
            'Summary',
            'Skills',
            'Experience',
            'Projects',
            'Education'
          ],
        );
}
